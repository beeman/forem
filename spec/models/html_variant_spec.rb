require "rails_helper"

RSpec.describe HtmlVariant, type: :model do
  let(:html_variant) { create(:html_variant, approved: true, published: true) }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:html) }
  it { is_expected.to belong_to(:user).optional }

  it "calculates success rate" do
    4.times { HtmlVariantTrial.create!(html_variant_id: html_variant.id) }
    HtmlVariantSuccess.create!(html_variant_id: html_variant.id)

    html_variant.calculate_success_rate!
    expect(html_variant.success_rate).to eq(0.025)
  end

  it "finds for test without tag" do
    html_variant.save!
    expect(described_class.find_for_test.id).to eq(html_variant.id)
  end

  it "finds for test with tag given" do
    html_variant.target_tag = "hello"
    html_variant.save!
    expect(described_class.find_for_test(["hello"]).id).to eq(html_variant.id)
  end

  it "does not find if different tag targeted" do
    html_variant.target_tag = "different_tag_yolo"
    html_variant.save!
    expect(described_class.find_for_test(["hello"])).to eq(nil)
  end

  it "finds if no tag targeted and tag given" do
    html_variant.update(target_tag: nil)
    expect(described_class.find_for_test(["hello"]).id).to eq(html_variant.id)
  end

  it "prefixes an image with cloudinary" do
    html = "<div><img src='https://devimages.com/image.jpg' /></div>"
    html_variant.update(approved: false, html: html)
    expect(html_variant.html).to include("/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_420/https://devimages.com/image.jpg")
  end
end
