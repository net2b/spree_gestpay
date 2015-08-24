module Gestpay
  class Mapping < Struct.new(:label)
    def self.default
      new(mapping.keys.first)
    end

    def self.from_code(code)
      mapping.reduce(nil) do |accu, (k, v)|
        v == code ? new(k) : accu
      end
    end

    def code
      self.class.mapping.fetch(label) { self.class.default.code }
    end

    def to_s
      label
    end

    def ==(other)
      self.label == other.label
    end
  end
end
