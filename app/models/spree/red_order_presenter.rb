module Spree
  class RedOrderPresenter < SimpleDelegator
    def red_data
      data = { red_fraud_prevention: 1.to_s }

      if user.present?
        addr = user.bill_address
        data['Red_CustomerInfo'] = {
          'Customer_Name'       => f.cut(29) { user.firstname.to_s.squish },
          'Customer_Surname'    => f.cut(29) { user.lastname.to_s.squish },
          'Customer_Email'      => f.cut(45) { user.email.to_s.squish },
          'Customer_Address'    => f.cut(29) { addr.address1.to_s.squish },
          'Customer_Address2'   => f.cut(29) { addr.address2.to_s.squish },
          'Customer_City'       => f.cut(19) { addr.city.to_s.squish },
          # 'Customer_StateCode'  => addr.state_name, # this is interpreted as 2 chars 'Province', we do not have this data
          'Customer_Country'    => addr.country.correct_iso3,
          'Customer_PostalCode' => f.cut(8) { addr.zipcode.to_s.squish },
          'Customer_Phone'      => f.cut(19) { f.digits { addr.phone } }
        }
      else
        data['Red_CustomerInfo'] = { 'Customer_Email' => f.cut(45) { email.to_s.squish } }
      end

      if ship_address.present?
        data['Red_ShippingInfo'] = red_address_data('Shipping', ship_address)
      end

      if bill_address.present?
        data['Red_BillingInfo'] = red_address_data('Billing', bill_address)
      end

      # For some reasons the vast majority of records does not hold this value.
      if last_ip_address.present?
        data['Red_CustomerData'] = {
          'Customer_IpAddress' => last_ip_address
        }
      end

      data['Red_Items'] = red_line_items

      f.compact_hash { data }
    end

    private

    # +kind+ => 'Billing' / 'Shipping'
    def red_address_data(kind, address)
      data = {
        'Name'       => f.cut(29) { address.firstname.to_s.squish },
        'Surname'    => f.cut(29) { address.lastname.to_s.squish },
        'Email'      => f.cut(44) { email.to_s.squish },
        'Address'    => f.cut(29) { address.address1.to_s.squish },
        'Address2'   => f.cut(29) { address.address2.to_s.squish },
        'City'       => f.cut(19) { address.city.to_s.squish },
        # 'StateCode'  => address.state_name.to_s.squish.cut(30),
        'Country'    => address.country.correct_iso3,
        'PostalCode' => f.cut(8) { address.zipcode.to_s.squish },
        'HomePhone'  => f.cut(18) { f.digits { address.phone } },
        # 'MobilePhone' => nil,
        # 'FaxPhone'    => nil,
        # 'TimeToDeparture => nil
      }

      data.map { |k, v| { [kind, k].join('_') => v } }.reduce(&:merge)
    end

    def red_line_items
      {
        number_of_items: line_items.size.to_s,
        red_item:        line_items.map do |li|
          {
            'Item_ProductCode' => f.cut(11) { li.product.name.squish },
            'Item_Description' => f.cut(25) { li.product.description.squish },
            'Item_Quantity'    => li.quantity * 10_000,
            'Item_UnitCost'    => (li.price * 100).to_i,
            'Item_TotalCost'   => li.quantity * (li.price * 100).to_i
            # 'Item_StockKeepingUnit' => nil,
            # 'Item_ShippingNumber' =>    nil,
            # 'Item_GiftMessage' =>       nil,
            # 'Item_PartEanNumber' =>    nil,
            # 'Item_ShippingComments' =>  nil
          }
        end
      }
    end

    class Formatter
      def compact_hash
        r = yield.delete_if { |_, v| v.nil? }
        r.each { |_, v| compact_hash { v } if v.is_a?(Hash) }
        r
      end

      def numeric
        (yield * 1e4).to_i
      rescue
        nil
      end

      def digits
        yield.scan(/\d/).join
      rescue
        nil
      end

      def cut(num)
        yield[0..num]
      rescue
        nil
      end
    end

    def f
      Formatter.new
    end
  end
end
