defmodule WeChat.SDK.Template do
  @moduledoc """
  消息管理 - 模板消息

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Template_Message_Interface.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Message_Management/Template_Message_Interface.html"

  @type template_id :: String.t()
  @type title :: String.t()
  @type description :: String.t()
  @type url :: String.t()
  @type pic_url :: String.t()
  @type industry_id :: integer

  @doc """
  设置所属行业

  ## API Docs
    [link](#{@doc_link}#0){:target="_blank"}
  """
  @spec api_set_industry(SDK.client(), industry_id, industry_id) :: SDK.response()
  def api_set_industry(client, industry_id1, industry_id2) do
    client.request(:post,
      url: "/cgi-bin/template/api_set_industry",
      body: json_map(industry_id1: industry_id1, industry_id2: industry_id2)
    )
  end

  @doc """
  获取设置的行业信息

  ## API Docs
    [link](#{@doc_link}#1){:target="_blank"}
  """
  @spec get_industry(SDK.client()) :: SDK.response()
  def get_industry(client) do
    client.request(:get, url: "/cgi-bin/template/get_industry")
  end

  @doc """
  获得模板ID

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec api_add_template(SDK.client(), template_id_short :: String.t()) :: SDK.response()
  def api_add_template(client, template_id_short) do
    client.request(:post,
      url: "/cgi-bin/template/api_add_template",
      body: json_map(template_id_short: template_id_short)
    )
  end

  @doc """
  获取模板列表

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec get_all_private_template(SDK.client()) :: SDK.response()
  def get_all_private_template(client) do
    client.request(:get, url: "/cgi-bin/template/get_all_private_template")
  end

  @doc """
  删除模板

  ## API Docs
    [link](#{@doc_link}#4){:target="_blank"}
  """
  @spec del_private_template(SDK.client(), template_id) :: SDK.response()
  def del_private_template(client, template_id) do
    client.request(:post,
      url: "/cgi-bin/template/del_private_template",
      body: json_map(template_id: template_id)
    )
  end

  @doc """
  发送模板消息

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec send_template_message(SDK.client(), SDK.openid(), template_id, data :: map) ::
          SDK.response()
  def send_template_message(client, openid, template_id, data) do
    client.request(
      :post,
      url: "/cgi-bin/message/template/send",
      body:
        json_map(
          touser: openid,
          template_id: template_id,
          data: data
        )
    )
  end

  @doc """
  发送模板消息

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec send_template_message(SDK.client(), body :: map) :: SDK.response()
  def send_template_message(client, body) do
    client.request(
      :post,
      url: "/cgi-bin/message/template/send",
      body: body
    )
  end
end
