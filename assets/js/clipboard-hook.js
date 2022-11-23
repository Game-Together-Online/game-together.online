export default {
    mounted() {
      const originalInnerHTML = this.el.innerHTML;
      const { content, successMessage } = this.el.dataset;

      this.el.addEventListener('click', () => {
        navigator.clipboard.writeText(content);
  
        this.el.innerHTML = successMessage;
  
        setTimeout(() => {
          this.el.innerHTML = originalInnerHTML;
        }, 2000);
      });
    },
  };