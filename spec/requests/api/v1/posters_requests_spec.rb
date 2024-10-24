require 'rails_helper'

RSpec.describe "Posters API", type: :request do
    before(:each) do
    @regret = Poster.create(
        name: "REGRET",
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
      
      @faiure = Poster.create(
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
      )
      
      @mediocrity = Poster.create(
        name: "MEDIOCRITY",
        description: "Dreams are just that—dreams.",
        price: 127.00,
        year: 2021,
        vintage: false,
        img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8",
      )
    end

    it "returns all posters" do

    get '/api/v1/posters'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(posters.count).to eq(3)

    posters.each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(Integer)

      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)

      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)

      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)
    end
  end

  it "can get one poster by its id" do
    id = Poster.create(
      name: "REGRET", 
      description: "Hard work rarely pays off.", 
      price: 89.00, 
      year: 2018, 
      vintage: true, 
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id

    get "/api/v1/posters/#{id}"

    poster = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(poster[:data]).to have_key(:id)
    expect(poster[:data][:id]).to be_an(Integer)

    expect(poster[:data][:attributes]).to have_key(:name)
    expect(poster[:data][:attributes][:name]).to be_a(String)

    expect(poster[:data][:attributes]).to have_key(:description)
    expect(poster[:data][:attributes][:description]).to be_a(String)

    expect(poster[:data][:attributes]).to have_key(:price)
    expect(poster[:data][:attributes][:price]).to be_a(Float)

    expect(poster[:data][:attributes]).to have_key(:year)
    expect(poster[:data][:attributes][:year]).to be_a(Integer)

    expect(poster[:data][:attributes]).to have_key(:vintage)
    expect(poster[:data][:attributes][:vintage]).to be_in([true, false])

    expect(poster[:data][:attributes]).to have_key(:img_url)
    expect(poster[:data][:attributes][:img_url]).to be_a(String)
  end

  it "can update an existing song" do
    id = Poster.create(
      name: "REGRET", 
      description: "Hard work rarely pays off.", 
      price: 89.00, 
      year: 2018, 
      vintage: true, 
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id
    previous_name = Poster.last.name
    poster_params = { name: "RAINBOWS" }
    headers = {"CONTENT_TYPE" => "application/json"}
    # We include this header to make sure that these params are passed as JSON rather than as plain text

    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
    poster = Poster.find_by(id: id)

    expect(response).to be_successful
    expect(poster.name).to_not eq(previous_name)
    expect(poster.name).to eq("RAINBOWS")
  end

  it "can destroy an song" do

    expect(Poster.count).to eq(3)

    delete "/api/v1/posters/#{@regret.id}"

    expect(response).to be_successful
    expect(Poster.count).to eq(2)
    expect{ Poster.find(@regret.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end