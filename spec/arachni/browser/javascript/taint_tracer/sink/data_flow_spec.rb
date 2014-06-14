require 'spec_helper'

describe Arachni::Browser::Javascript::TaintTracer::Sink::DataFlow do
    it_should_behave_like 'sink'

    subject { Factory[:data_flow] }

    %w(source function arguments object tainted taint).each do |m|
        it { should respond_to m }
        it { should respond_to "#{m}=" }
    end

    it "supports #{Arachni::RPC::Serializer}" do
        subject.should == Arachni::RPC::Serializer.deep_clone( subject )
    end

    describe '#to_rpc_data' do
        let(:data) { subject.to_rpc_data }

        %w(source function arguments object tainted taint).each do |attribute|
            it "includes '#{attribute}'" do
                data[attribute.to_sym].should == subject.send( attribute )
            end
        end
    end

    describe '.from_rpc_data' do
        let(:restored) { described_class.from_rpc_data data }
        let(:data) { Arachni::RPC::Serializer.rpc_data( subject ) }

        %w(source function arguments object tainted taint).each do |attribute|
            it "restores '#{attribute}'" do
                restored.send( attribute ).should == subject.send( attribute )
            end
        end
    end

    describe '#to_h' do
        it 'returns a hash containing frame data' do
            subject.to_h.should == Factory[:data_flow]
        end

        it 'is aliased to #to_hash' do
            subject.to_h.should == subject.to_hash
        end
    end
end
