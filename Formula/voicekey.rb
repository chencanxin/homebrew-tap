class Voicekey < Formula
  desc "VoiceKey Mac receiver: phone types Chinese over LAN, paste at Mac cursor"
  homepage "https://github.com/chencanxin/voicekey-dist"
  version "0.7.1"
  url "https://codeload.github.com/chencanxin/voicekey-dist/tar.gz/d0e6ca5b5361a52b832f51658dbc261560451678"
  sha256 "b0a0c5808670c83c92affbec5e37067050136e8831d075ee53922bacd9e85358"
  license "MIT"

  depends_on "go" => :build

  def install
    # 国内网络：走 goproxy.cn 拉模块，校验库用国内镜像
    ENV["GOPROXY"] = "https://goproxy.cn,direct"
    ENV["GOSUMDB"] = "sum.golang.google.cn"
    cd "macrecv" do
      system "go", "build", "-trimpath", "-ldflags", "-s -w", "-o", bin/"voicekey", "."
    end
  end

  def caveats
    <<~EOS
      启动：终端运行 voicekey（会自动打开浏览器仪表盘，数据端口 7979）。
      首次运行后需授权一次：系统设置 → 隐私与安全性 → 辅助功能 → 勾选 voicekey。
      更新检查已内置：启动时自动比对版本，有新版本会提示（brew upgrade voicekey）。
    EOS
  end
end
