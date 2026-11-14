class Voicekey < Formula
  desc "VoiceKey Mac receiver: phone types Chinese over LAN, paste at Mac cursor"
  homepage "https://github.com/chencanxin/voicekey-dist"
  version "0.7.8"
  url "https://codeload.github.com/chencanxin/voicekey-dist/tar.gz/6d486ee86b536531bee3b606a9464fcb5409c34c"
  sha256 "af9ded3abc6544a3d00f09ce0607ac14956b14bf984288751cdf99f6aed4908f"
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
      自更新已内置：每 60 秒自动检查新版本，自动 brew upgrade 并自重启（辅助功能授权可能需重新勾选一次）。
    EOS
  end
end
