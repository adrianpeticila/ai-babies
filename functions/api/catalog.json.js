/**
 * GET /api/catalog.json — the fixed product catalog.
 * Every item has exactly the 7 contract keys; prices are fixed in USD.
 */
import { PRODUCTS, catalogItem, json } from "../../lib/commerce.js";

export function onRequestGet() {
  return json(PRODUCTS.map(catalogItem));
}
