module GreenspaceHelper
  def find_greenspace_images(greenspace)
    base_path = Rails.root.join('app', 'assets', 'images', 'greenspaces')
    pattern = File.join(base_path, "#{greenspace.name.parameterize}_*.jpg")
    Dir.glob(pattern).map { |path| File.basename(path) }
  end
end
