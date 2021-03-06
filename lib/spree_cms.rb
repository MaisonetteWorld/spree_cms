require 'spree_core'
require 'spree_cms/engine'
require 'spree_cms/railtie'
require 'sir_trevor_rails'

module StaticPage
  module_function

  def remove_spree_mount_point(path)
    regex = Regexp.new '\A' + Rails.application.routes.url_helpers.spree_path
    path.sub(regex, '').split('?')[0]
  end
end

module Spree
  class StaticPage
    def self.matches?(request)
      return false if request.path =~ %r{\A\/+(admin|account|cart|checkout|content|login|pg\/|orders|products|s\/|session|signup|shipments|states|t\/|tax_categories|user)+}
      !Spree::Page.visible.find_by_slug(request.path).nil?
    end
  end
end
