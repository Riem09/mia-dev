require "spec_helper"

describe Api::MotifsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/motifs").should route_to("api/motifs#index")
    end

    it "routes to #new" do
      get("/api/motifs/new").should route_to("api/motifs#new")
    end

    it "routes to #show" do
      get("/api/motifs/1").should route_to("api/motifs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/api/motifs/1/edit").should route_to("api/motifs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/api/motifs").should route_to("api/motifs#create")
    end

    it "routes to #update" do
      put("/api/motifs/1").should route_to("api/motifs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api/motifs/1").should route_to("api/motifs#destroy", :id => "1")
    end

  end
end
