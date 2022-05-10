# frozen_string_literal: true

module Controllers
  # Base class for the controllers of the application, allowing for a more
  # route-focused syntax in each of them by putting shared methods here.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Base < Core::Controllers::Base
    configure do
      set :root, File.absolute_path(File.join(File.dirname(__FILE__), '..'))
      set :views, (proc { File.join(root, 'views') })
      set :public_folder, File.join(settings.root, 'public')
    end
  end
end
