defmodule WeChat.SDK.SubscribeMessage do
  @moduledoc """
  订阅信息

  同时支持

  - [公众号](https://developers.weixin.qq.com/doc/offiaccount/Subscription_Messages/intro.html)
  - [小程序](https://developers.weixin.qq.com/miniprogram/dev/framework/open-ability/subscribe-message.html)
  """
  import Jason.Helpers
  alias WeChat.SDK
  @doc_link "https://developers.weixin.qq.com/miniprogram/dev"

  @typedoc """
  小程序页面路径

  最大长度 `128` 字节，不能为空；对于小游戏，可以只传入 `query` 部分，来实现传参效果，如：传入 `?foo=bar`，
  即可在 `wx.getLaunchOptionsSync` 接口中的 `query` 参数获取到 `{foo:"bar"}`。
  """
  @type path :: String.t()

  @typedoc "模板id"
  @type template_id :: String.t()
  @typedoc "个人模板id"
  @type pri_tmpl_id :: String.t()
  @typedoc """
  模板标题 id

  可通过接口获取，也可登录 公众号/小程序 后台查看获取
  """
  @type tid :: String.t()
  @typedoc """
  开发者自行组合好的模板关键词列表

  关键词顺序可以自由搭配（例如 [3,5,4] 或 [4,5,3]），最多支持5个，最少2个关键词组合
  """
  @type kid_list :: [String.t()]
  @typedoc """
  服务场景描述

  15个字以内
  """
  @type scene_desc :: String.t()
  @typedoc "类目ID"
  @type category_id :: String.t()
  @type send_data :: map | Keyword.t() | Enumerable.t()
  @typedoc """
  跳转小程序类型

  - 开发版： `:developer`
  - 体验版： `:trial`
  - 正式版： `:formal`

  默认为: 正式版
  """
  @type mini_program_state :: String.t() | :developer | :trial | :formal
  @typedoc """
  进入小程序查看”的语言类型

  支持:

  - 简体中文: `zh_CN`
  - 英文: `en_US`
  - 繁体中文: `zh_HK`
  - 繁体中文: `zh_TW`

  默认为: `zh_CN`
  """
  @type lang :: String.t()
  @typedoc "跳转网页时填写"
  @type jump_page_url :: String.t()
  @type send_options :: official_account_send_options | mini_program_send_options
  @type jump_mini_program_object :: %{
          appid: SDK.appid(),
          pagepath: path
        }
  @typedoc """
  公众号 发送配置

  - `page` 和 `miniprogram` 同时不填，无跳转；
  - `page` 和 `miniprogram` 同时填写，优先跳转小程序；
  """
  @type official_account_send_options :: %{
          optional(:page) => jump_page_url,
          optional(:miniprogram) => jump_mini_program_object
        }
  @typedoc """
  小程序 发送配置
  """
  @type mini_program_send_options :: %{
          optional(:page) => path,
          optional(:miniprogram_state) => mini_program_state,
          optional(:lang) => lang
        }

  @doc_link "#{@doc_link}/api-backend/open-api/subscribe-message"

  @doc """
  组合模板并添加至帐号下的个人模板库 -
  [官方文档](#{@doc_link}/subscribeMessage.addTemplate.html){:target="_blank"}
  """
  @spec add_template(SDK.client(), tid, kid_list, scene_desc) :: SDK.response()
  def add_template(client, tid, kid_list, scene_desc \\ "") do
    client.request(:post,
      url: "/wxaapi/newtmpl/addtemplate",
      body: json_map(tid: tid, kidList: kid_list, sceneDesc: scene_desc)
    )
  end

  @doc """
  删除帐号下的个人模板 -
  [官方文档](#{@doc_link}/subscribeMessage.deleteTemplate.html){:target="_blank"}
  """
  @spec delete_template(SDK.client(), pri_tmpl_id) :: SDK.response()
  def delete_template(client, pri_tmpl_id) do
    client.request(:post,
      url: "/wxaapi/newtmpl/deltemplate",
      body: json_map(priTmplId: pri_tmpl_id)
    )
  end

  @doc """
  获取小程序账号的类目 -
  [官方文档](#{@doc_link}/subscribeMessage.getCategory.html){:target="_blank"}
  """
  @spec get_category(SDK.client()) :: SDK.response()
  def get_category(client) do
    client.request(:get, url: "/wxaapi/newtmpl/getcategory")
  end

  @doc """
  获取模板标题下的关键词列表 -
  [官方文档](#{@doc_link}/subscribeMessage.getPubTemplateKeyWordsById.html){:target="_blank"}
  """
  @spec get_pub_template_key_words_by_id(SDK.client(), tid) :: SDK.response()
  def get_pub_template_key_words_by_id(client, tid) do
    client.request(:get, url: "/wxaapi/newtmpl/getpubtemplatekeywords", query: [tid: tid])
  end

  @doc """
  获取帐号所属类目下的公共模板标题 -
  [官方文档](#{@doc_link}/subscribeMessage.getPubTemplateTitleList.html){:target="_blank"}
  """
  @spec get_pub_template_titles(
          SDK.client(),
          [category_id],
          start :: non_neg_integer,
          limit :: 1..30
        ) :: SDK.response()
  def get_pub_template_titles(client, ids, start \\ 0, limit \\ 30) do
    client.request(:get,
      url: "/wxaapi/newtmpl/getpubtemplatetitles",
      query: [
        ids: Enum.join(ids, ","),
        start: start,
        limit: limit
      ]
    )
  end

  @doc """
  获取当前帐号下的个人模板列表 -
  [官方文档](#{@doc_link}/subscribeMessage.getTemplateList.html){:target="_blank"}
  """
  @spec get_templates(SDK.client()) :: SDK.response()
  def get_templates(client) do
    client.request(:get, url: "/wxaapi/newtmpl/gettemplate")
  end

  @doc """
  发送订阅消息

  - [公众号](#{SDK.doc_link_prefix()}/offiaccount/Subscription_Messages/api.html#send发送订阅通知){:target="_blank"}
  - [小程序](#{@doc_link}/subscribeMessage.send.html){:target="_blank"}
  """
  @spec send(SDK.client(), SDK.openid(), template_id, send_data, send_options) ::
          SDK.response()
  def send(client, openid, template_id, data, options \\ %{}) do
    data = Enum.into(data, %{}, fn {k, v} -> {k, %{value: v}} end)

    client.request(:post,
      url: "/cgi-bin/message/subscribe/send",
      body: Map.merge(options, %{touser: openid, template_id: template_id, data: data})
    )
  end
end
