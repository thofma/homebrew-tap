class Bibi < Formula
  desc "Retrieve BibTeX for mathematical literature"
  homepage "https://github.com/thofma/bibi"
  license "MIT"
  url "https://github.com/thofma/bibi/releases/download/v0.5.0/bibi_0.5.0_source.tar.gz"
  version "0.5.0"
  sha256 "b21cefe1b78784cdcdd965aca7c7cce18d194d61a61a8594abd6082b45374e2d"
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/thofma/bibi/internal/buildinfo.Version=#{version} -X github.com/thofma/bibi/internal/buildinfo.Commit=9e6101ce25187244876cfbe74e959b1456f45ba9"
    system "go", "build", "-trimpath", "-mod=readonly", "-ldflags", ldflags, "-o", bin/"bibi", "."
    generate_completions_from_executable(bin/"bibi", "completion", shell_parameter_format: :cobra)
    pkgshare.install "internal/journals/README.md" => "journals.md"
  end

  test do
    assert_match "bibi v#{version}", shell_output("#{bin}/bibi --version")
    assert_equal "Invent. Math.\n", shell_output("#{bin}/bibi abbr inventiones mathematicae")
  end
end
