require "anonymous_loader"
require "sanitize_email"
RSpec.describe SanitizeEmail::Version do
  it_behaves_like "a Version module", described_class

  it "executes the version file for coverage without redefining constants" do
    paths = [
      File.expand_path("../../lib/sanitize_email/version.rb", __dir__),
      File.expand_path("../../lib/sanitize_email/version_gem.rb", __dir__)
    ].select { |path| File.file?(path) }
    anonymous_namespace = AnonymousLoader.load(files: paths)

    expect(anonymous_namespace::SanitizeEmail::Version::VERSION).to eq(described_class::VERSION)
  end
end
