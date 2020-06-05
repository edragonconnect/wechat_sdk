defmodule WeChat.SDK.CustomService do
  @moduledoc """
  客服帐号管理

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Service_Center_messages.html#0){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Service_Center_messages.html"

  @type kf_account :: String.t
  @type nickname :: String.t
  @type password :: String.t

  @doc """
  添加客服帐号

  ## API Docs
    [link](#{@doc_link}#1){:target="_blank"}
  """
  @spec add_kf_account(SDK.client, kf_account, nickname, password) :: SDK.response
  def add_kf_account(client, kf_account, nickname, password) do
    client.request(
      :post,
      url: "/cgi-bin/customservice/kfaccount/add",
      body: json_map(
        kf_account: kf_account,
        nickname: nickname,
        password: password
      )
    )
  end

  @doc """
  修改客服帐号

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec update_kf_account(SDK.client, kf_account, nickname, password) :: SDK.response
  def update_kf_account(client, kf_account, nickname, password) do
    client.request(
      :post,
      url: "/cgi-bin/customservice/kfaccount/update",
      body: json_map(
        kf_account: kf_account,
        nickname: nickname,
        password: password
      )
    )
  end

  @doc """
  删除客服帐号

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec del_kf_account(SDK.client, kf_account, nickname, password) :: SDK.response
  def del_kf_account(client, kf_account, nickname, password) do
    client.request(
      :post,
      url: "/cgi-bin/customservice/kfaccount/del",
      body: json_map(
        kf_account: kf_account,
        nickname: nickname,
        password: password
      )
    )
  end

  #@doc """
  #设置客服帐号的头像
  # ## API Docs
  #  [link](#{@doc_link}#4){:target="_blank"}
  #"""
  #@spec upload_head_img(SDK.client, kf_account, file_path :: Path.t) :: SDK.response
  #def upload_head_img(client, kf_account, file_path) do
  #  # todo upload file_path
  #  client.request(
  #    :post,
  #    url: "/cgi-bin/customservice/kfaccount/uploadheadimg",
  #    query: [
  #      kf_account: kf_account
  #    ]
  #  )
  #end

  @doc """
  获取所有客服账号

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec get_kf_list(SDK.client) :: SDK.response
  def get_kf_list(client) do
    client.request(:get, url: "/cgi-bin/customservice/getkflist")
  end
end
