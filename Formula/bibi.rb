class Bibi < Formula
  desc "Retrieve BibTeX for mathematical literature"
  homepage "https://github.com/thofma/bibi"
  license "MIT"
  url "https://github.com/thofma/bibi/releases/download/v0.6.0/bibi_0.6.0_source.tar.gz"
  version "0.6.0"
  sha256 "d5bb0e8d12f1fff83a9ae51d37d8c37b76e7050d03d24e9d0f742cd3db3fba8d"
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/thofma/bibi/internal/buildinfo.Version=#{version} -X github.com/thofma/bibi/internal/buildinfo.Commit=b8ab1f733540637a96a39e911718d8f7942a2f30"
    system "go", "build", "-trimpath", "-mod=readonly", "-ldflags", ldflags, "-o", bin/"bibi", "."
    generate_completions_from_executable(bin/"bibi", "completion", shell_parameter_format: :cobra)
    pkgshare.install "internal/journals/README.md" => "journals.md"
  end

  test do
    assert_match "bibi v#{version}", shell_output("#{bin}/bibi --version")
    assert_equal "Invent. Math.\n", shell_output("#{bin}/bibi abbr inventiones mathematicae")
  end
end
