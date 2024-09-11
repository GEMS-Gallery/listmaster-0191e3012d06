import { backend } from 'declarations/backend';

const form = document.getElementById('add-item-form');
const input = document.getElementById('new-item');
const list = document.getElementById('shopping-list');

async function loadItems() {
    const items = await backend.getItems();
    list.innerHTML = '';
    items.forEach(item => addItemToDOM(item));
}

function addItemToDOM(item) {
    const li = document.createElement('li');
    li.className = `shopping-item ${item.completed ? 'completed' : ''}`;
    li.innerHTML = `
        <span class="shopping-item-text">${item.text}</span>
        <button class="delete-btn"><i class="fas fa-trash"></i></button>
    `;
    li.addEventListener('click', () => toggleItem(item.id));
    li.querySelector('.delete-btn').addEventListener('click', (e) => {
        e.stopPropagation();
        deleteItem(item.id);
    });
    list.appendChild(li);
}

async function addItem(text) {
    await backend.addItem(text);
    loadItems();
}

async function toggleItem(id) {
    await backend.toggleItem(id);
    loadItems();
}

async function deleteItem(id) {
    await backend.deleteItem(id);
    loadItems();
}

form.addEventListener('submit', (e) => {
    e.preventDefault();
    if (input.value.trim()) {
        addItem(input.value.trim());
        input.value = '';
    }
});

loadItems();
