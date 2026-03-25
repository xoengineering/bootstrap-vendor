module Bootstrap
  module Vendor
    class Railtie < Rails::Railtie
      rake_tasks do
        load File.expand_path('../../tasks/bootstrap.rake', __dir__)
      end
    end
  end
end
