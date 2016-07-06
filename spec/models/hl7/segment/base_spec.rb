require 'rails_helper'

module HL7
  module Segment
    describe Base do
      describe '.field' do
        let(:subject) { Class.new(described_class) }

        it 'defines new attribute' do
          subject.field(:chunky_bacon)
          expect(subject.new).to respond_to(:chunky_bacon)
        end

        it 'defines new attribute with default' do
          subject.field(:chunky_bacon, default: 'Chunky Bacon')
          expect(subject.new.chunky_bacon).to eq 'Chunky Bacon'
        end

        it 'stores attribute name' do
          subject.field(:chunky)
          subject.field(:bacon)
          expect(subject.field_names).to eq [:chunky, :bacon]
        end
      end

      describe '#type' do
        let(:subject) do
          module ChunkyBacon
            class FooBar < Base; end
          end
          ChunkyBacon::FooBar.new
        end

        it 'returns first 3 letters of upcased class name' do
          expect(subject.type).to eq 'FOO'
        end
        
        context 'with anonymous class' do
          let(:subject) { Class.new(described_class).new }

          it 'returns empty string' do
            # ...to make sure that specs with anon. class don't break.
            expect(subject.type).to eq ''
          end
        end
      end

      describe '#to_hl7' do
        let(:subject) do
          class Foo < described_class
            field :chunky
            field :bacon
          end
          foo = Foo.new(chunky: 1, bacon: 2)
        end

        it 'joins type and ordered fields by pipe' do
          expect(subject.to_hl7).to eq 'FOO|1|2'
        end

        it 'is aliased to #to_s' do
          expect(subject.to_hl7).to eq subject.to_s
        end

        it 'exports datetime into correct format' do
          klass = Class.new(Base)
          klass.field :timestamp, type: DateTime

          time = Time.zone.parse('2016-05-13T11:50:01+02:00')
          subject = klass.new
          subject.timestamp = time

          expect(subject.to_hl7).to include '20160513115001'
        end
      end

      describe '#fields' do
        let(:subject) do
          class Foo < described_class
            field :chunky
            field :bacon
          end
          Foo.new
        end

        it 'is an alias for #attributes' do
          subject.fields = { chunky: 1, bacon: 2 }
          expect(subject.fields).to eq({'chunky' => 1, 'bacon' => 2})
        end
      end
    end
  end
end
