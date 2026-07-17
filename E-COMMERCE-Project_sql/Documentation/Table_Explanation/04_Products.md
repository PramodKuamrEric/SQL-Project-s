1[products-table-image](Tables-image/create-table-products.png)

English Explanation


```sql
CREATE TABLE categories (

```

A new table named `categories` is being created — used to organize products (e.g., "Electronics", "Mobiles", "Laptops", etc.).

---

```sql
category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

```

* Each category has its own unique ID, which is automatically generated.
* **`PRIMARY KEY`** — The main unique identifier for this table.

---

```sql
category_name VARCHAR(150) NOT NULL,

```

* The name of the category (e.g., "Electronics", "Mobiles").
* **`NOT NULL`** — A category cannot be created without a name.

---

```sql
parent_category_id BIGINT UNSIGNED DEFAULT NULL,

```

Here is where the really interesting part comes in:

* This column points to another category **within the same `categories` table**.
* Meaning, if the "Mobiles" category falls under "Electronics", the `parent_category_id` of the "Mobiles" row will be the `category_id` of "Electronics".
* **`DEFAULT NULL`** — If a category is a main/top-level category (like "Electronics", which doesn't fall under any other category), its `parent_category_id` will remain `NULL`. `NULL` in this context means "this has no parent; it is a top-level category."

---

```sql
CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
    ON DELETE SET NULL,

```

This is a **self-referencing foreign key** — the most important concept here:

* **`FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)`** — Normally, a foreign key references another table (like `addresses.user_id` → `users.user_id`), but here, the `categories` table is referencing its own `category_id` column.
* This creates a hierarchy or tree structure:
```text
Electronics (category_id=1, parent_category_id=NULL)
    └── Mobiles (category_id=3, parent_category_id=1)
    └── Laptops (category_id=4, parent_category_id=1)
Clothing (category_id=2, parent_category_id=NULL)
    └── Men's Wear (category_id=5, parent_category_id=2)

```


* **`ON DELETE SET NULL`** — This behavior is different from the `ON DELETE CASCADE` used in the `addresses` table, and it is used here very intentionally:
* If you delete "Electronics" (the parent category), its sub-categories ("Mobiles", "Laptops") will **not** be deleted.
* Instead, their `parent_category_id` will automatically become `NULL` — meaning "Mobiles" will now become an orphaned top-level category, but it will not be deleted.
* This is done so that deleting a parent category doesn't accidentally wipe out all the sub-categories and their associated products — keeping the data safe.



---

---

**Summary in one line:**
The `categories` table organizes categories into a hierarchy (parent → sub-category) using a self-referencing foreign key; top-level categories have a `NULL` parent, while sub-categories store their parent's ID, and `ON DELETE SET NULL` ensures that deleting a parent only unlinks the sub-categories rather than deleting them (a safer approach than cascading).

### 💡 Key Takeaway: The Difference in `ON DELETE` Behaviors

| Behavior | What Happens? | Where is it used? |
| --- | --- | --- |
| **CASCADE** | The child row is also deleted. | `addresses` (User is deleted → their addresses are also deleted) |
| **SET NULL** | The child row remains, but the link becomes NULL. | `categories` (Parent is deleted → sub-category becomes an orphan but isn't deleted) |
| **RESTRICT** | Deletion is blocked as long as child records exist. | (Used in the `products` table where deleting a category in use is restricted) |

```

```

Hinglish Explanation



```sql
CREATE TABLE categories (
```
Ek naya table **`categories`** banaya jaa raha hai — products ko organize karne ke liye (jaise "Electronics", "Mobiles", "Laptops" etc.).

---

```sql
category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
```
- Har category ka apna unique ID, automatically generate hota hai.
- **`PRIMARY KEY`** — is table ka main unique identifier.

---

```sql
category_name VARCHAR(150) NOT NULL,
```
- Category ka naam (jaise "Electronics", "Mobiles"). 
- **`NOT NULL`** — naam ke bina category create nahi ho sakti.

---

```sql
parent_category_id BIGINT UNSIGNED DEFAULT NULL,
```
Yahan asli interesting cheez hai:
- Yeh column **`categories` table ke andar hi kisi doosri category ko point karta hai**.
- Yani agar "Mobiles" category "Electronics" ke andar aati hai, to "Mobiles" row ka `parent_category_id` = "Electronics" ka `category_id` hoga.
- **`DEFAULT NULL`** — agar koi category **main/top-level category** hai (jaise "Electronics" khud kisi ke andar nahi aati), to uska `parent_category_id` **NULL** rahega. NULL yahan ka matlab hai "iska koi parent nahi hai, yeh top-level hai."

---

```sql
CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
    ON DELETE SET NULL,
```
Yeh **self-referencing foreign key** hai — sabse important concept:

- **`FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)`** — normally foreign key doosre table ko reference karta hai (jaise `addresses.user_id` → `users.user_id`), lekin yahan `categories` table apne hi `category_id` column ko reference kar raha hai.
- Isse **hierarchy/tree structure** banti hai:
  ```
  Electronics (category_id=1, parent_category_id=NULL)
      └── Mobiles (category_id=3, parent_category_id=1)
      └── Laptops (category_id=4, parent_category_id=1)
  Clothing (category_id=2, parent_category_id=NULL)
      └── Men's Wear (category_id=5, parent_category_id=2)
  ```
- **`ON DELETE SET NULL`** — yeh `addresses` table ke `ON DELETE CASCADE` se **different behavior** hai, aur yahan iska istemaal sochkar kiya gaya hai:
  - Agar aap "Electronics" (parent category) delete karte ho, to iske sub-categories ("Mobiles", "Laptops") delete **nahi** hongi.
  - Balki unka `parent_category_id` automatically **NULL** ho jaayega — matlab "Mobiles" ab ek orphan top-level category ban jaayegi, delete nahi hogi.
  - Yeh isliye kiya gaya kyunki parent category delete hone ka matlab yeh nahi hona chahiye ki uske sub-categories ke saare products bhi gayab ho jaayein — data safe rehta hai.

---



---

**Summary ek line me:** `categories` table categories ko hierarchy (parent → sub-category) me organize karta hai using self-referencing foreign key. Top-level categories ka `parent_category_id` NULL hota hai, sub-categories apne parent ka `category_id` store karti hain. Agar parent delete ho jaaye, to sub-categories delete nahi hoti — bas unka link NULL ho jaata hai (`ON DELETE SET NULL`), jo `addresses` table ke `ON DELETE CASCADE` se ekdum different aur safer approach hai is case ke liye.

**Yaad rakhne wali cheez — teeno `ON DELETE` behaviors ka farak:**
| Behavior | Kya hota hai | Kahan use hua |
|---|---|---|
| `CASCADE` | Child row bhi delete ho jaati hai | `addresses` (user delete → uske addresses bhi delete) |
| `SET NULL` | Child row rehti hai, bas link NULL ho jaata hai | `categories` (parent delete → sub-category orphan ban jaati hai, delete nahi hoti) |
| `RESTRICT` | Delete hone hi nahi diya jaata jab tak child records hain | (aapke `products` table me category delete restrict hai) |

