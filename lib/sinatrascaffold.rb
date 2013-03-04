# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'sinatra/base'
require 'will_paginate'
require 'will_paginate/active_record'

WillPaginate.per_page = 10

module Sinatra
  module Scaffold

    attr_accessor :database_connection, :hidden_columns, :searchable_columns, :scaffold_tables

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
      hidden_columns[table] ? (table_columns(table) - hidden_columns[table]) : table_columns(table)
    end

    def table_columns(table)
      database_connection.columns(table).collect {|column| column.name.to_sym }
    end

    def tables
      ActiveRecord::Base.descendants.map(&:name).map {|x| x.constantize.table_name.to_sym}
    end

    def models
      ActiveRecord::Base.descendants.map(&:name).map {|x| x.constantize}
    end

    # can be used to configure multiple tables at once
    class Config
      attr_reader :tables, :app

      def initialize tables, app
        @tables = tables
        @app = app
      end

      def hide(*columns)
        tables.each { |table| app.hidden_columns[table] += columns.flatten }
      end

      def show(*columns)
        tables.flatten.each { |table| columns.each { |e| app.hidden_columns[table].delete_if { |x| x == e }  } }
      end

      def only(*columns)
        tables.flatten.each { |table|
          app.hidden_columns[table] = app.table_columns(table)
          columns.flatten.each { |e| app.hidden_columns[table].delete_if { |x| x == e }  }
        }
      end

      def search(*columns)
        tables.each { |table| app.searchable_columns[table] += columns }
      end
    end

    def scaffold(tablez, &block)
      set_defaults unless defaults_set?
      tablez = (tablez == :all ? tables : [tablez].flatten)
      tablez.each { |table| (scaffold_tables << table) unless scaffold_tables.include? table }
      config = Config.new(tablez, self)
      yield(config) if block_given?
      prepare_actions(config)
    end

    private

    def get_action(model, app)
      table = model.name.pluralize.underscore
      get "/#{table}" do
        table = table.to_sym
        page = params[:page] ? params[:page].to_i : 1
        dataset = model.page(params[:page])
        erb :index, :locals => {:dataset => dataset, :schema => app.columns(table), :table => table, :searchable_columns => app.searchable_columns[table] }

      end
    end

    def delete_action(model, app)
      table = model.name.pluralize.underscore
      delete "/#{table}/:id" do
        if request.xhr?
          record = model.where(:id => params[:id].to_i).first
          if record && record.destroy
            status 200 and return
          else
            status 404 and return
          end
        end
        status 403 and return
      end
    end

    # def show_actions(model, app)
    #   table = model.name.pluralize.underscore
    #   get "/#{table}/:id" do
    #     model.where(:id => params[:id]).first.to_json(:except => app.hidden_columns[table.to_sym].flatten)
    #   end
    # end

    def defaults_set?
     !(hidden_columns.nil? && searchable_columns.nil? && scaffold_tables.nil?)
    end

    def set_defaults
      raise "Please specify database" unless database_connection
      set :views,  File.expand_path('../views', __FILE__)
      set :public_folder,  File.expand_path('../public', __FILE__)
      self.hidden_columns, self.searchable_columns, self.scaffold_tables = {}, {}, []
      tables.each { |table| self.hidden_columns[table], self.searchable_columns[table]  = [], [] }
    end

    def prepare_actions(config)
      models.each do |model|
        self.instance_eval { [:get, :delete].each { |e| send("#{e}_action", model, self) } }
      end
    end

  end
end
