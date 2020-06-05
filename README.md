# WeChat SDK

**微信SDK for Elixir(WIP)**

This `SDK` build up on [elixir_wechat](https://github.com/edragonconnect/elixir_wechat)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wechat_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wechat_sdk, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/wechat_sdk](https://hexdocs.pm/wechat_sdk).

## Usage

### 定义 `Client` 模块

```elixir

# 普通(`default`):

defmodule YourApp.WeChat.CodeName do
  @moduledoc "CodeName"
  use WeChat.SDK,
    role: :common,
    appid: "wx-appid",
    adapter_storage: {:default, "https://hub.base_url"}
end

# or

# 第三方应用:

defmodule YourApp.WeChat.CodeName do
  @moduledoc "CodeName"
  use WeChat.SDK,
    role: :component,
    authorizer_appid: "wx-third-appid", # 第三方 appid
    appid: "wx-appid",
    adapter_storage: {:default, "https://hub.base_url"}
end
```

### 调用接口

同时支持两种方式调用

```elixir
YourApp.WeChat.CodeName.Material.batch_get_material(:image, 2)

# or

WeChat.SDK.Material.batch_get_material(YourApp.WeChat.CodeName, :image, 2)
```
### 支持接口列表

[官方文档](https://developers.weixin.qq.com/doc/offiaccount/Getting_Started/Overview.html)

* 消息管理
* 素材管理
* 图文消息留言管理
* 用户管理
* 账号管理
* 微信卡券(WIP)

更多接口目前还在开发中……

如果有接口未覆盖到，欢迎提交`PR`
