// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// This example demonstrates a basic use of a shared greeting.
/// Rules:
/// - anyone can create and share a Greeting object
/// - everyone can update the text of the Greeting object
module hello_world::greeting {
  use std::string;

  /// A shared greeting
  public struct Greeting has key {
    id: UID,
    text: string::String,
  }
 
  /// API call that creates a globally shared Greeting object initialized with "Hello world!"
  public fun new(ctx: &mut TxContext) { 
    let new_greeting = Greeting { 
      id: object::new(ctx),
      text: b"Hello world!".to_string()
    };
    transfer::share_object(new_greeting);
  }

  /// API call that updates text of Greeting object
  public fun update_text(greeting: &mut Greeting, new_text: string::String) {
    greeting.text = new_text;
  }

  public fun text(greeting: &Greeting): string::String {
    greeting.text
  }
}
