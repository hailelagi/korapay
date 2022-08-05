defmodule KoraPay.ParseError do
  @moduledoc false

  require Logger

  def call({:ok, %{status: 400, body: body}}) do
    Logger.error("[korapay] Bad request #{inspect(body)}")
    {:error, %{reason: body["error"], details: body["message"]}}
  end

  def call({:ok, %{status: 401, body: body}}) do
    Logger.error("[korapay] Resource not available. #{inspect(body)}")
    {:error, %{reason: body["error"], details: body["message"]}}
  end

  def call({:ok, %{status: 403, body: body}}) do
    Logger.error("[korapay] Forbidden. #{inspect(body)}")
    {:error, %{reason: body["error"], details: body["message"]}}
  end

  def call({:ok, %{status: 404, body: body}}) do
    Logger.warn("[korapay] resource not found. #{inspect(body)}")
    {:error, %{reason: body["error"], details: body["message"]}}
  end

  def call({:ok, %{status: 500, body: body}}) do
    Logger.error("[korapay] Internal server error encountered #{inspect(body)}")
    {:error, %{reason: "internal error", details: body["message"]}}
  end

  def call(error) do
    Logger.error("[korapay] #{inspect(error)}")
    {:error, %{reason: "unexpected error", details: "unknown"}}
  end
end
