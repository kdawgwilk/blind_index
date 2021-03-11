# Blind Index

Securely search encrypted database fields. Inspired heavily by [ankane/blind_index](https://github.com/ankane/blind_index)

[![Build Status](https://github.com/kdawgwilk/blind_index/workflows/build/badge.svg?branch=master)](https://github.com/kdawgwilk/blind_index/actions)

## How It Works

We use [this approach](https://paragonie.com/blog/2017/05/building-searchable-encrypted-databases-with-php-and-sql) by Scott Arciszewski. To summarize, we compute a keyed hash of the sensitive data and store it in a column. To query, we apply the keyed hash function to the value we’re searching and then perform a database search. This results in performant queries for exact matches.

## Leakage

An important consideration in searchable encryption is leakage, which is information an attacker can gain. Blind indexing leaks that rows have the same value. If you use this for a field like last name, an attacker can use frequency analysis to predict the values. In an active attack where an attacker can control the input values, they can learn which other values in the database match.

Here’s a [great article](https://blog.cryptographyengineering.com/2019/02/11/attack-of-the-week-searchable-encryption-and-the-ever-expanding-leakage-function/) on leakage in searchable encryption. Blind indexing has the same leakage as [deterministic encryption](#alternatives).

## Installation

Add `blind_index` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blind_index, "~> 0.1.0"}
  ]
end
```

## Prep

TODO

## Getting Started

Create a migration to add a column for the blind index

```elixir
add :email_bidx, :string
add index :users, [:email_bidx]
# unique_index if needed
# add unique_index :users, [:email_bidx]
```

Add to your model

```elixir
defmodule User do
  use Ecto.Schema
  import BlindIndex, only: [blind_index: 1]

  schema "users" do
    blind_index :email
  end
end
```

For more sensitive fields, use

```elixir
defmodule User do
  use Ecto.Schema
  import BlindIndex, only: [blind_index: 2]

  schema "users" do
    blind_index :email, sensitive: true
  end
end
```

Backfill existing records

```elixir
BlindIndex.backfill(User)
```

## Key Separation

The master key is used to generate unique keys for each blind index. This technique comes from [CipherSweet](https://ciphersweet.paragonie.com/internals/key-hierarchy). The table name and blind index column name are both used in this process. If you need to rename a table with blind indexes, or a blind index column itself, get the key:

```elixir
BlindIndex.index_key("users", "email_bidx")
```

## Key Generation

Generate a key with:

```elixir
BlindIndex.generate_key()
```

Store the key with your other secrets. This is typically an environment variable. Be sure to use different keys in development and production. Keys don’t need to be hex-encoded, but it’s often easier to store them this way.

Set the following environment variable with your key (you can use this one in development)

```sh
BLIND_INDEX_MASTER_KEY=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
```

## Alternatives

One alternative to blind indexing is to use a deterministic encryption scheme, like AES-SIV. In this approach, the encrypted data will be the same for matches. We recommend blind indexing over deterministic encryption because:

1. You can keep encryption consistent for all fields (both searchable and non-searchable)
2. Blind indexing supports expressions

## History

View the [changelog](https://github.com/kdawgwilk/blind_index/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/kdawgwilk/blind_index/issues)
- Fix bugs and [submit pull requests](https://github.com/kdawgwilk/blind_index/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development and testing:

```sh
git clone https://github.com/kdawgwilk/blind_index.git
cd blind_index
mix deps.get
mix test
```

For security issues, send an email to the address on [this page](https://github.com/kdawgwilk).
