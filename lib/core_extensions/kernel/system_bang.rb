module CoreExtensions
  module Kernel
    module SystemBang
      def system!(*args)
        system(*args) || abort("\n== Command #{args} failed ==")
      end
    end
  end
end
