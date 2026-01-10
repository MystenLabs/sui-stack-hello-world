// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module hello_world::greeting_tests;

use std::unit_test::assert_eq;
use sui::test_scenario;

use hello_world::greeting::{Self, Greeting};

#[test]
fun test_create_shared_greeting_has_default_text() {
  let sender = @0xA;
  let mut scenario = test_scenario::begin(sender);

  greeting::new(test_scenario::ctx(&mut scenario));

  test_scenario::next_tx(&mut scenario, sender);

  let greeting_obj = test_scenario::take_shared<Greeting>(&scenario);
  assert_eq!(greeting::text(&greeting_obj), b"Hello world!".to_string());
  test_scenario::return_shared(greeting_obj);

  test_scenario::end(scenario);
}

#[test]
fun test_anyone_can_update_shared_greeting_and_it_persists() {
  let creator = @0xA;
  let updater = @0xB;
  let mut scenario = test_scenario::begin(creator);

  greeting::new(test_scenario::ctx(&mut scenario));

  // End creation tx; run next tx as a different sender.
  test_scenario::next_tx(&mut scenario, updater);

  {
    let mut greeting_obj = test_scenario::take_shared<Greeting>(&scenario);
    greeting::update_text(&mut greeting_obj, b"Hola Sui".to_string());
    assert_eq!(greeting::text(&greeting_obj), b"Hola Sui".to_string());
    test_scenario::return_shared(greeting_obj);
  };

  // End update tx; ensure changes are visible in a subsequent tx.
  test_scenario::next_tx(&mut scenario, creator);

  let greeting_obj = test_scenario::take_shared<Greeting>(&scenario);
  assert_eq!(greeting::text(&greeting_obj), b"Hola Sui".to_string());
  test_scenario::return_shared(greeting_obj);

  test_scenario::end(scenario);
}
