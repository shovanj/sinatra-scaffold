require 'sinatra/base'

module Sinatra
  module Scaffold
    class Config
      class << self
        attr_accessor :configuration
      end
    end

    def configure_scaffold(&block)
      yield
    end

    def scaffold(options)
      # converint :user, :expense to User, Expense
      models = options[:models].inject([]) do |result, element|
        result  <<  Extlib::Inflection.constantize(element.to_s.capitalize)
        result
      end
      Config.configuration = models
    end
  end
  register Scaffold
end


module Sinatra
  module Scaffold
    module Helpers
      def clear_params model_name
        #delete any params key that is empty
        params[:"#{model_name}"].delete_if { |key,value| value.strip == '' }
      end
    end

    module Search
      def prepare_like_condition params, model_name
        conditions = []
        clear_params model_name
        params[:"#{model_name}"].each do |key,value|
          conditions << ":#{key}.like => '%#{value}%'"
        end
        return conditions
      end
    end

    class << self
      def registered(app)
        app.helpers Scaffold::Helpers
        app.helpers Scaffold::Search
        # if user has not specified which models, use all the models
        models = Sinatra::Scaffold::Config.configuration || DataMapper::Model.descendants

        models.each do |model|
          tabelized_name = Extlib::Inflection.tableize(model.name)
          # creates routes for models in the db
          # eg: /admin/users, /admin/categories
          app.get "/admin/#{tabelized_name}" do
            @model, @records = model, model.all
            haml :admin, :layout => false
          end
        
          # creates search routes for models
          # eg /admin/users/search, /admin/categories/search
          app.get "/admin/#{tabelized_name}/search" do
            @model     = model
            conditions = prepare_like_condition(params, model.name.downcase)
            @records   = eval"@model.all(#{conditions.join(',')})"
            haml :admin, :layout => false
          end
        end
      end
    end
  end
end



