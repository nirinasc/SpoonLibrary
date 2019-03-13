# config/initializers/swagger_ui_engine.rb

SwaggerUiEngine.configure do |config|
    config.swagger_url = {
      v1: 'swagger.json'
    }
  end