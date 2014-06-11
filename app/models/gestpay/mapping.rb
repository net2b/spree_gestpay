module Gestpay
  class Mapping < Struct.new(:label)
    def self.default
      new(mapping.keys.first)
    end

    def code
      self.class.mapping[label]
    end

    def to_s
      label
    end

    def ==(other)
      self.label == other.label
    end
  end
end
