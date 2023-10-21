# frozen_string_literal: true

require 'spec_helper'
require 'i18n'
require 'ostruct'

# Set up I18n configuration
I18n.available_locales = [:en]
I18n.default_locale = :en

RSpec.describe HumanizeEnum do
  class Payment
    include HumanizeEnum::Helpers
    attr_accessor :status

    def self.model_name
      OpenStruct.new(i18n_key: 'payment')
    end

    def initialize(status = nil)
      @status = status
    end

    def self.defined_enums
      {
        'status' => {
          'initial' => 1,
          'paid' => 2,
          'error' => 3,
          'InitialStatus' => 4,
          'Initial-Status' => 5
        }
      }
    end

    def self.statuses
      defined_enums['status']
    end
  end

  # Set up translations for the Payment class
  I18n.backend.store_translations(:en, activerecord: {
    attributes: {
      payment: {
        'status/initial': 'Initial status',
        'status/paid': 'Payment processed',
        'status/error': 'Payment error',
        'status/initial/status': 'Initial status',  # For camel-cased enum values
        'status/initial_status': 'Initial status'   # For enum values with special characters
      }
    }
  })

  module HumanizeEnum
    UnknownEnumKey = Class.new(StandardError)
  end

  let(:payment) { Payment.new('initial') }

  describe '.humanize_enum' do
    it 'returns the translated value of an enum' do
      expect(Payment.humanize_enum(:status, :initial)).to eq('Initial status')
      expect(Payment.humanize_enum(:status, :paid)).to eq('Payment processed')
    end

    it 'raises UnknownEnumKey when an undefined enum name is passed' do
      expect { Payment.humanize_enum(:undefined_enum, :pending) }.to raise_error(HumanizeEnum::UnknownEnumKey)
    end
  end

  describe '.humanize_enums' do
    it 'returns a hash of enum values and their translations' do
      expect(Payment.humanize_enums(:status)).to eq({
                                                      'initial' => 'Initial status',
                                                      'paid' => 'Payment processed',
                                                      'error' => 'Payment error'
                                                    })
    end
  end

  describe '.dehumanize_enum' do
    it 'returns the enum value from a translated enum text' do
      expect(Payment.dehumanize_enum(:status, 'Initial status')).to eq('initial')
      expect(Payment.dehumanize_enum(:status, 'Payment processed')).to eq('paid')
      expect(Payment.dehumanize_enum(:status, 'Payment error')).to eq('error')
      expect(Payment.dehumanize_enum(:status, 'Non-existing status')).to be_nil
    end
  end

  describe '.enum_options' do
    it 'returns an array of SelectOption structs' do
      options = Payment.enum_options(:status)
      expect(options).to all(be_an(HumanizeEnum::Helpers::SelectOption))
    end

    it 'contains the correct id, value, text, and checked attributes for each SelectOption' do
      options = Payment.enum_options(:status)
      expect(options).to contain_exactly(
                           have_attributes(id: 1, value: 'initial', text: 'Initial status', checked: nil),
                           have_attributes(id: 2, value: 'paid', text: 'Payment processed', checked: nil),
                           have_attributes(id: 3, value: 'error', text: 'Payment error', checked: nil)
                         # Add more expectations for other enum values if necessary
                         )
    end

    it 'raises UnknownEnumKey when an undefined enum name is passed' do
      expect { Payment.enum_options(:undefined_enum) }.to raise_error(HumanizeEnum::UnknownEnumKey)
    end
  end

  describe '#humanize_enum' do
    it 'returns the translated enum value of an instance' do
      payment = Payment.new('initial')
      expect(payment.humanize_enum(:status)).to eq('Initial status')

      payment.status = 'paid'
      expect(payment.humanize_enum(:status)).to eq('Payment processed')

      payment.status = 'error'
      expect(payment.humanize_enum(:status)).to eq('Payment error')
    end

    it 'raises UnknownEnumKey when an undefined enum name is passed' do
      expect { payment.humanize_enum(:undefined_enum) }.to raise_error(HumanizeEnum::UnknownEnumKey)
    end
  end

  describe '.humanize_enum with special enum values' do
    it 'handles camel-cased enum values' do
      expect(Payment.humanize_enum(:status, :InitialStatus)).to eq('Initial status')
    end

    it 'handles enum values with special characters' do
      expect(Payment.humanize_enum(:status, :"Initial-Status")).to eq('Initial status')
    end
  end

  describe '#humanize_enum instance method with special enum values' do
    it 'handles camel-cased enum values' do
      payment = Payment.new('InitialStatus')
      expect(payment.humanize_enum(:status)).to eq('Initial status')
    end

    it 'handles enum values with special characters' do
      payment = Payment.new('Initial-Status')
      expect(payment.humanize_enum(:status)).to eq('Initial status')
    end
  end


end
