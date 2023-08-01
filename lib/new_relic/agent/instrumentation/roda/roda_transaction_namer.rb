# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/newrelic-ruby-agent/blob/main/LICENSE for complete details.
# frozen_string_literal: true

module NewRelic
  module Agent
    module Instrumentation
      module Roda
        module TransactionNamer
          extend self

          ROOT = '/'.freeze
          REGEX_MUTIPLE_SLASHES = %r{^[/^\\A]*(.*?)[/\$\?\\z]*$}.freeze

          def transaction_name(request)
            verb = http_verb(request)
            path = request.path || ::NewRelic::Agent::UNKNOWN_METRIC
            name = path.gsub(REGEX_MUTIPLE_SLASHES, '\1') # remove any rogue slashes
            name = ROOT if name.empty?
            name = "#{verb} #{name}" unless verb.nil?

            name
          rescue => e
            ::NewRelic::Agent.logger.debug("#{e.class} : #{e.message} - Error encountered trying to identify Roda transaction name")
            ::NewRelic::Agent::UNKNOWN_METRIC
          end

          def http_verb(request)
            request.request_method if request.respond_to?(:request_method)
          end
        end
      end
    end
  end
end
