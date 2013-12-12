$:.unshift File.dirname(__FILE__) # allows command line to execute tests
require 'helper'

class MappingTest < Test::Unit::TestCase

  context 'a new instance' do

    setup do
      @rate = Stamps::Mapping::Rate.new({
          :from_zip_code => '45440',
          :to_zip_code   => '45458',
          :weight_oz     => '7.8',
          :package_type  => 'Package',
          :service_type  => 'US-PM',
          :add_ons       => {
            :add_on => [
              { :amount  => '2.30', :type => 'US-A-RR' },
              { :amount  => '0.19', :type => 'US-A-DC' }
            ]
          }
        })
    end

    should 'map :to property fields' do
      assert_equal @rate.to_hash['FromZIPCode'], '45440'
      assert_equal @rate.to_hash['ToZIPCode'], '45458'
      assert_equal @rate.to_hash['WeightOz'], '7.8'
      assert_equal @rate.to_hash['PackageType'], 'Package'
      assert_equal @rate.to_hash['ServiceType'], 'US-PM'
    end

  end

  context 'customs item' do
    setup do
      @customs = Stamps::Mapping::Customs.new({
      :content_type=>"Other",
      :comments => 'What a lovely shipment',
      :license_number => 'License 123',
      :certificate_number => 'ABC 123',
      :invoice_number => 'Invoice 123',
      :other_describe=>"Other description.",
      :customs_lines=> {
        :custom => [
          {:description=>"my product name 1",
          :quantity=>1,
          :value=>5.99,
          :weight_lb=>0,
          :weight_oz=>4,
          :country_of_origin=>"US"},
          {:description=>"my product name 2",
          :quantity=>1,
          :value=>5.99,
          :weight_lb=>0,
          :weight_oz=>4,
          :country_of_origin=>"US"},
          {:description=>"my product name 3",
          :quantity=>1,
          :value=>5.99,
          :weight_lb=>0,
          :weight_oz=>4,
          :country_of_origin=>"US"}
        ]
      }}).to_hash
    end

    should 'map to CustomLine fields properly' do
      assert_equal @customs['ContentType'], 'Other'
      assert_equal @customs['Comments'], 'What a lovely shipment'
      assert_equal @customs['LicenseNumber'], 'License 123'
      assert_equal @customs['CertificateNumber'], 'ABC 123'
      assert_equal @customs['InvoiceNumber'], 'Invoice 123'
      assert_equal @customs['OtherDescribe'], 'Other description.'
      assert_equal @customs['CustomsLines'].length, 1
      assert_equal @customs['CustomsLines']["CustomsLine"].length, 3
      assert_equal @customs['CustomsLines']["CustomsLine"][0]["Description"], "my product name 1"
      assert_equal @customs['CustomsLines']["CustomsLine"][1]["Description"], "my product name 2"
      assert_equal @customs['CustomsLines']["CustomsLine"][2]["Description"], "my product name 3"
    end
  end
end
