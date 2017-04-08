module Requests
  module JsonHelpers
    def jsoned
      JSON.parse(response.body)
    end
  end
end