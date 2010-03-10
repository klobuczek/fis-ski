class Redirecter
  def initialize(app, target)
    @app = app
    @target = target
  end

  def call(env)

    if env['HTTP_HOST'] == @target
      @app.call(env)
    else
      [301, {"Location" => "http://#{@target}"}, 'Redirecting you to the new location...']
    end
  end
end