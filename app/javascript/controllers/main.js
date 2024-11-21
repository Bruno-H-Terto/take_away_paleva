export function ola() {
  console.log('ola');
}

export function showModal(dialog){
  const id = dialog.id;
  saveModalContent(id);
  const modal = document.querySelector(`#${id}`);
  modal.showModal();
}

export function closeModal(dialog){
  const id = dialog.id
  const modal = document.querySelector(`#${id}`);
  modal.close();
  restoreModalContent(id);
}

const modalOriginalContent = {};

function saveModalContent(modalId) {
  const modal = document.getElementById(modalId);
  if (modal && !modalOriginalContent[modalId]) {
    modalOriginalContent[modalId] = modal.innerHTML;
  }
}

function restoreModalContent(modalId) {
  const modal = document.getElementById(modalId);
  if (modal && modalOriginalContent[modalId]) {
    modal.innerHTML = modalOriginalContent[modalId];
  }
}
