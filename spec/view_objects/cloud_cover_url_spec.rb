require "rails_helper"

RSpec.describe CloudCoverUrl, type: :view_object do
  let(:article) { create(:article) }
  let(:cloudinary_prefix) { "https://res.cloudinary.com/TEST-CLOUD/image/fetch/" }

  it "returns proper url" do
    expect(described_class.new(article.main_image).call)
      .to start_with(cloudinary_prefix)
      .and include("/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://robohash.org/")
  end

  it "returns proper url when nested cloudinary" do
    image_url = "https://res.cloudinary.com/practicaldev/image/fetch/s--A-gun7rr--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://res.cloudinary.com/practicaldev/image/fetch/s--hcD8ZkbP--/c_imagga_scale%2Cf_auto%2Cfl_progressive%2Ch_420%2Cq_auto%2Cw_1000/https://dev-to-uploads.s3.amazonaws.com/i/th93d625o27nuz63oeen.png"

    article.update_column(:main_image, image_url)
    expect(described_class.new(article.main_image).call)
      .to start_with(cloudinary_prefix)
      .and end_with("/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/th93d625o27nuz63oeen.png")
  end

  it "returns proper url when single cloudinary" do
    image_url = "https://res.cloudinary.com/practicaldev/image/fetch/s--hcD8ZkbP--/c_imagga_scale%2Cf_auto%2Cfl_progressive%2Ch_420%2Cq_auto%2Cw_1000/https://dev-to-uploads.s3.amazonaws.com/i/th93d625o27nuz63oeen.png"

    article.update_column(:main_image, image_url)
    expect(described_class.new(article.main_image).call)
      .to start_with(cloudinary_prefix)
      .and end_with("/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/th93d625o27nuz63oeen.png")
  end
end
