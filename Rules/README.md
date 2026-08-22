# Rules/

## Composite indexes

A Firestore query that combines `where(field == …)` with `order(by:
otherField)` needs a composite index — a single-field index (automatic for every
field) is not enough once two different fields are involved. This app has two:

| Collection | Index |
|---|---|
| `cards` | `userId` Ascending, `createdAt` Ascending |
| `bookings` | `userId` Ascending, `createdAt` Descending |

### How you'll find out one is missing

The query fails with an error in the Xcode console like:

```
[FirebaseFirestore][I-FST000001] Listen for query at bookings|f:userId==...|ob:createdAtdesc...
failed: The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/...
```

The app only shows a generic toast ("we couldn't load your tickets") — the real
reason is always in that console line, not on screen.

### Creating one

Fastest way — the link Firestore prints already encodes the right collection,
fields and sort order:

1. Copy the `https://console.firebase.google.com/v1/r/project/...` link from the
   Xcode console.
2. Open it, signed in with an account that has access to the Firebase project.
3. The console opens a **Create Index** form already filled in. Click **Create**.
4. Wait for the status to go from **Building** to **Enabled**.

Without a link:

1. Firebase Console → **Firestore Database → Indexes → Composite → Create Index**.
2. **Collection ID**: `cards` or `bookings`.
3. **Fields to index**: add them in the order listed in the table above.
4. **Query scope**: Collection.
5. **Create**, then wait for **Enabled**.
