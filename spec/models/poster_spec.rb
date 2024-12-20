require 'rails_helper'

RSpec.describe "validations", type: :model do
        it "is valid with all attributes" do
            poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: 89.00,
                year: 2018,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to be_valid
        end

        it "is invalid without a name" do
            poster = Poster.create(
                name: nil,
                description: "Hard work rarely pays off.",
                price: 89.00,
                year: 2018,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:name]).to include("can't be blank")
        end

        it "is invalid if name is not unique" do
            poster = Poster.create(
                name: "Natasha's Personalities",
                description: "It's like a choose your own adventure",
                price: 102.00,
                year: 2024,
                vintage: false,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            poster2 = Poster.create(
                name: "Natasha's Personalities",
                description: "Wow",
                price: 100.00,
                year: 2024,
                vintage: false,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster2).to_not be_valid
            expect(poster2.errors[:name]).to include("has already been taken")
        end

        it "is invalid without a description" do
            poster = Poster.create(
                name: "REGRET",
                description: nil,
                price: 89.00,
                year: 2018,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:description]).to include("can't be blank")
        end

        it "is invalid without a year" do
        poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: 89.00,
                year: nil,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:year]).to include("can't be blank")
        end

        it "is invalid if year is not an integer" do
            poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: 89.00,
                year: "twenty-eighteen",
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:year]).to include("is not a number")
        end

        it "is invalid without a price" do
            poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: nil,
                year: 2018,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:price]).to include("can't be blank")
        end

        it "is invalid if price is not a float" do
            poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: "Eighty-Nine",
                year: 2018,
                vintage: true,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:price]).to include("is not a number")
        end

        it "is invalid without vintage set to true or false" do
            poster = Poster.create(
                name: "REGRET",
                description: "Hard work rarely pays off.",
                price: 89.00,
                year: 2018,
                vintage: nil,
                img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                )

            expect(poster).to_not be_valid
            expect(poster.errors[:vintage]).to include("must be true or false")
        end
    
end