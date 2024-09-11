import Bool "mo:base/Bool";

import List "mo:base/List";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {
  // Define the structure for a shopping list item
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Use stable var for persistence across upgrades
  stable var items: List.List<ShoppingItem> = List.nil();
  stable var nextId: Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    let newItem: ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    items := List.push(newItem, items);
    nextId += 1;
    id
  };

  // Toggle the completion status of an item
  public func toggleItem(id: Nat) : async Bool {
    items := List.map(items, func (item: ShoppingItem) : ShoppingItem {
      if (item.id == id) {
        return {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
      };
      item
    });
    true
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    items := List.filter(items, func (item: ShoppingItem) : Bool {
      item.id != id
    });
    true
  };

  // Get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    List.toArray(items)
  };
}
