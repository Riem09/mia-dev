module Mia
  class DiagnosticMiddleware

    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env)
    rescue StandardError => error
      puts error.message
      puts error.backtrace
      raise error
    end
  end
end
