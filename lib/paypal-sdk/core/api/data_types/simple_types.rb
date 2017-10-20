require 'date'

module PayPal::SDK::Core
  module API
    module DataTypes

      module SimpleTypes
        class String < ::String
          def self.new(string = "")
            string.is_a?(::String) ? super : super(string.to_s)
          end

          def to_yaml_type
            "!tag:yaml.org,2002:str"
          end
        end

        class Integer < ::Integer
          def self.new(number)
            number.to_i
          end
        end

        class Float < ::Float
          def self.new(float)
            # Floats are inccurate. BigDecimal is better.
            # Ruby example: 2.20 - 2.01 = 0.1900000000000004
            # To support currencies with up to 4 subunits, we round(4)
            # Reference 1: https://stackoverflow.com/a/3730040/1109211
            # Reference 2: https://stackoverflow.com/a/3730249/1109211
            BigDecimal.new(float.to_f.round(4).to_s)
          end
        end

        class Boolean
          def self.new(boolean)
            ( boolean == 0 || boolean == "" || boolean =~ /^(false|f|no|n|0)$/i ) ? false : !!boolean
          end
        end

        class Date < ::Date
          def self.new(date)
            date.is_a?(::Date) ? date : Date.parse(date.to_s)
          end
        end

        class DateTime < ::DateTime
          def self.new(date_time)
            date_time = "0001-01-01T00:00:00" if date_time.to_s == "0"
            date_time.is_a?(::DateTime) ? date_time : parse(date_time.to_s)
          end
        end
      end

    end
  end
end
