# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'sinatra/base'
require 'sequel'

Sequel.extension :pagination

module Sinatra
  module Scaffold

    attr_accessor :hidden_columns, :searchable_columns, :database, :scaffold_tables

    module ScaffoldHelpers
      # add helpers here
    end

    class << self
      def registered(app)
        app.helpers ScaffoldHelpers
      end
    end

    def columns(table)
      raise "Please please set up defaults first" unless hidden_columns
      hidden_columns[table] ? (database[table].columns - hidden_columns[table]) : database[table].columns
    end

    def tables
      database.tables
    end

    # can be used to configure multiple tables at once
    class Config
      attr_reader :tables, :app

      def initialize tables, app
        @tables = tables
        @app = app
      end

      def hide(*columns)
        tables.each { |table| app.hidden_columns[table] += columns }
      end

      def show(*columns)
        tables.flatten.each { |table| columns.each { |e| app.hidden_columns[table].delete_if { |x| x == e }  } }
      end

      def only(*columns)
        tables.flatten.each { |table|
          app.hidden_columns[table] = app.database[table].columns
          columns.each { |e| app.hidden_columns[table].delete_if { |x| x == e }  }
        }
      end

      def search(*columns)
        tables.each { |table| app.searchable_columns[table] += columns }
      end
    end

    def set_database(db)
      self.database = db
    end

    def scaffold(tablez, &block)
      set_defaults unless defaults_set?
      tablez = (tablez == :all ? database.tables : [tablez].flatten)
      tablez.each { |table| (scaffold_tables << table) unless scaffold_tables.include? table }
      config = Config.new(tablez, self)
      yield(config) if block_given?
      prepare_actions(config)
    end

    private

    def get_actions(table, app)
      get "/#{table}" do
        page = params[:page] ? params[:page].to_i : 1
        filters = params[:q] ? params[:q].collect { |k,v|  k.to_sym.ilike("%#{v}%") } : []
        dataset = app.database[table].filter(filters).paginate(page, 15)
        erb :index, :locals => {:dataset => dataset, :schema => app.columns(table), :table => table, :searchable_columns => app.searchable_columns[table], :tables => app.scaffold_tables }
      end
    end

    def show_actions(table, app)
      get "/#{table}/:id" do
        record = app.database[table.to_sym].where(:id => params[:id]).first
        erb :show, :locals => {:record => record, :table => table, :schema => app.columns(table) }
      end
    end

    def defaults_set?
     !(hidden_columns.nil? && searchable_columns.nil? && scaffold_tables.nil?)
    end

    def set_defaults
      raise "Please specify database" unless database
      set :views,  File.expand_path('../views', __FILE__)
      set :public_folder,  File.expand_path('../public', __FILE__)
      self.hidden_columns, self.searchable_columns, self.scaffold_tables = {}, {}, []
      tables.each { |table| self.hidden_columns[table], self.searchable_columns[table]  = [], [] }
    end

    def prepare_actions(config)
      config.tables.each do |table|
        self.instance_eval { [:get, :show].each { |e| send("#{e}_actions", table, self) } }
      end
    end
  end
end
