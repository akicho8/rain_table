require "active_support/core_ext/kernel/concern"

module RainTable
  concern :ActiveRecord do
    class_methods do
      def to_t(options = {})
        RainTable.generate(all.collect(&:attributes), options)
      end
    end

    def to_t(options = {})
      RainTable.generate(attributes, options)
    end
  end
end

Kernel.class_eval do
  private

  def tt(object, options = {})
    if object.respond_to?(:to_t)
      object.to_t(options).display
    else
      RainTable.generate([{object.class.name => object}], {:header => false}.merge(options)).display
    end
  end
end

Array.class_eval do
  def to_t(options = {})
    RainTable.generate(self, options)
  end
end

Hash.class_eval do
  def to_t(options = {})
    RainTable.generate(self, options)
  end
end

[Symbol, String, Numeric].each do |klass|
  klass.class_eval do
    def to_t(options = {})
      RainTable.generate([{self.class.name => self}], {:header => false}.merge(options))
    end
  end
end
