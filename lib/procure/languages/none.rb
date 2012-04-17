module Procure
  module Languages
    module None
      class << self
        def recognize
          true
        end

        def create_role; end
      end
    end
  end
end