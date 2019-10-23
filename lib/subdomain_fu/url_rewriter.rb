require 'action_dispatch/routing/route_set'

module ActionDispatch
  module Routing
    module UrlForWithSubdomains
      def url_for(options, path_segments = nil, url_strategy = RouteSet::UNKNOWN)
        if options[:only_path] == false && SubdomainFu.needs_rewrite?(options[:subdomain], (options[:host] || @request.host_with_port))
          options[:only_path] = false if SubdomainFu.override_only_path?
          options[:host] = SubdomainFu.rewrite_host_for_subdomains(options.delete(:subdomain), options[:host] || @request.host_with_port)
          # puts "options[:host]: #{options[:host].inspect}"
        else
          options.delete(:subdomain)
        end
        super(options, path_segments, url_strategy)
      end
    end
    class RouteSet #:nodoc:
      prepend UrlForWithSubdomains
    end
  end
end
