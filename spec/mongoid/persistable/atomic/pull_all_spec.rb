require "spec_helper"

describe Mongoid::Persistable::Atomic::PullAll do

  describe "#persist" do

    context "when the field exists" do

      let(:person) do
        Person.create(aliases: [ "007" ])
      end

      let!(:pulled) do
        person.pull_all(:aliases, [ "007" ])
      end

      let(:reloaded) do
        person.reload
      end

      it "pulls the value from the array" do
        expect(person.aliases).to be_empty
      end

      it "persists the data" do
        expect(reloaded.aliases).to be_empty
      end

      it "removes the field from the dirty attributes" do
        expect(person.changes["aliases"]).to be_nil
      end

      it "resets the document dirty flag" do
        expect(person).to_not be_changed
      end

      it "returns the new array value" do
        expect(pulled).to be_empty
      end
    end

    context "when the field does not exist" do

      let(:person) do
        Person.create
      end

      let!(:pulled) do
        person.pull_all(:aliases, [ "Bond" ])
      end

      let(:reloaded) do
        person.reload
      end

      it "does not modify the field" do
        expect(person.aliases).to be_nil
      end

      it "persists no data" do
        expect(reloaded.aliases).to be_nil
      end

      it "removes the field from the dirty attributes" do
        expect(person.changes["aliases"]).to be_nil
      end

      it "resets the document dirty flag" do
        expect(person).to_not be_changed
      end

      it "returns nil" do
        expect(pulled).to be_nil
      end
    end
  end
end
