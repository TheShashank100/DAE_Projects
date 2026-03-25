import { useState } from 'react'
import './App.css'

const CATEGORIES = ['Produce', 'Dairy', 'Bakery', 'Meat', 'Other']

function App() {
  const [items, setItems] = useState([])
  const [name, setName] = useState('')
  const [category, setCategory] = useState('Produce')
  const [filterCategory, setFilterCategory] = useState('All')

  // Handling Events: form submission
  function handleSubmit(e) {
    e.preventDefault()
    if (!name.trim()) return
    const newItem = { id: Date.now(), name: name.trim(), category, bought: false }
    setItems([...items, newItem])
    setName('')
  }

  // Handling Events: toggle bought status
  function handleToggle(id) {
    setItems(items.map(item =>
      item.id === id ? { ...item, bought: !item.bought } : item
    ))
  }

  // Handling Events: delete item
  function handleDelete(id) {
    setItems(items.filter(item => item.id !== id))
  }

  // Rendering Lists: filter() then map()
  const visibleItems = items
    .filter(item => filterCategory === 'All' || item.category === filterCategory)

  const boughtCount = items.filter(i => i.bought).length

  return (
    <div className="app">
      <h1>Shopping List</h1>

      {/* Conditional Rendering: summary badge only when there are items */}
      {items.length > 0 && (
        <p className="summary">
          {boughtCount} / {items.length} items bought
        </p>
      )}

      {/* Forms: add item form */}
      <form onSubmit={handleSubmit} className="add-form">
        <input
          type="text"
          placeholder="Item name..."
          value={name}
          onChange={e => setName(e.target.value)}
        />
        <select value={category} onChange={e => setCategory(e.target.value)}>
          {CATEGORIES.map(cat => (
            <option key={cat} value={cat}>{cat}</option>
          ))}
        </select>
        <button type="submit">Add</button>
      </form>

      {/* Filter buttons — Handling Events: onClick */}
      <div className="filters">
        {['All', ...CATEGORIES].map(cat => (
          <button
            key={cat}
            className={filterCategory === cat ? 'active' : ''}
            onClick={() => setFilterCategory(cat)}
          >
            {cat}
          </button>
        ))}
      </div>

      {/* Conditional Rendering: empty state vs list */}
      {items.length === 0 ? (
        <p className="empty">Your list is empty. Add an item above!</p>
      ) : visibleItems.length === 0 ? (
        <p className="empty">No items in this category.</p>
      ) : (
        // Rendering Lists: map() over filtered array
        <ul className="item-list">
          {visibleItems.map(item => (
            <li key={item.id} className={item.bought ? 'bought' : ''}>
              <span className="item-category">{item.category}</span>
              <span className="item-name">{item.name}</span>
              <button onClick={() => handleToggle(item.id)}>
                {item.bought ? 'Undo' : 'Bought'}
              </button>
              <button className="delete" onClick={() => handleDelete(item.id)}>
                Remove
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

export default App
