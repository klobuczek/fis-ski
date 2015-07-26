require "rails_helper"

RSpec.describe PenaltiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/penalties").to route_to("penalties#index")
    end

    it "routes to #new" do
      expect(:get => "/penalties/new").to route_to("penalties#new")
    end

    it "routes to #show" do
      expect(:get => "/penalties/1").to route_to("penalties#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/penalties/1/edit").to route_to("penalties#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/penalties").to route_to("penalties#create")
    end

    it "routes to #update" do
      expect(:put => "/penalties/1").to route_to("penalties#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/penalties/1").to route_to("penalties#destroy", :id => "1")
    end

  end
end
