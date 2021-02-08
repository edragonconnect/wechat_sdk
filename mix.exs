defmodule WeChat.SDK.MixProject do
  use Mix.Project

  def project do
    [
      app: :wechat_sdk,
      description: "WeChat SDK for Elixir",
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_wechat, "~> 0.4"},
      {:ex_doc, "~> 0.22", only: [:docs, :dev], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      formatter_opts: [gfm: true],
      extras: ["README.md"],
      groups_for_modules: [
        {
          "用户管理 APIs",
          [
            # 用户管理
            WeChat.SDK.User,
            # 用户管理 - 标签管理
            WeChat.SDK.UserTag,
            # 用户管理 - 黑名单管理
            WeChat.SDK.UserBlacklist
          ]
        },
        {
          "消息管理 APIs",
          [
            # 消息管理 - 客服消息
            WeChat.SDK.CustomMessage,
            # 消息管理 - 客服帐号管理
            WeChat.SDK.CustomService,
            # 消息管理 - 模板消息
            WeChat.SDK.Template,
            # 消息管理 - 群发接口和原创效验
            WeChat.SDK.BatchSends
          ]
        },
        {"微信卡券 APIs",
         [
           # 微信卡券(WIP)
           WeChat.SDK.Card,
           # 微信卡券 - 管理卡券
           WeChat.SDK.CardManaging,
           # 微信卡券 - 投放卡券
           WeChat.SDK.CardDistributing
         ]},
        {
          "Other APIs",
          [
            # 素材管理
            WeChat.SDK.Material,
            # 图文消息留言管理
            WeChat.SDK.Comment,
            # 账号管理
            WeChat.SDK.Account,
            # JS-SDK(WIP)
            WeChat.SDK.JS,
            # 第三方平台
            WeChat.SDK.Component,
            # 小程序
            WeChat.SDK.MiniProgram
          ]
        },
        {"Basic Types", [WeChat.SDK]},
        {"Structure", [WeChat.SDK.Article]}
      ]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["feng19"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/edragonconnect/wechat_sdk"}
    ]
  end
end
