const container = document.querySelector('.container');
const options = document.querySelector('.options');
const header = document.querySelector('.header');
let troep;

const onClick = (e) => {
    e.preventDefault();
    let option;
    if (e.target.firstElementChild) {
        option = e.target.dataset.value;

    } else {
        option = e.target.parentElement.dataset.value;
    }

    container.style.visibility = 'hidden';
    fetchNui('select', {
        option: option,
        value: troep
    });
}
// const onClick = (e) => {
//     e.preventDefault();
//     let option;
//     if (e.target.firstElementChild) {
//         option = e.target.dataset.value;
//     } else {
//         option = e.target.parentElement.dataset.value;
//     }

//     container.style.visibility = 'hidden';
//     fetchNui('select', {
//         option: option
//     });
// }

const fetchNui = async (callback, payload) => {
    const response = await fetch(`https://${GetParentResourceName()}/${callback}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(payload)
    });
    return await response.json();
}

window.addEventListener('message', (e) => {
    const data = e.data;
    troep = e.data;
    if (data.type === 'newDialogue') {
        container.style.visibility = 'visible';
        options.innerHTML = '';
        const title = data.title;
        header.innerText = title;
        const items = data.items;
        items.forEach((el) => {
            const div = document.createElement('div');
            div.setAttribute('data-value', el.value);
            div.className = 'option';
            const text = document.createElement('p');
            text.innerText = el.text;
        
            div.appendChild(text)
            options.appendChild(div);

            div.addEventListener('click', onClick)
        })
    } else if(data.type === "close") {
        container.style.visibility = 'hidden';
    }
})