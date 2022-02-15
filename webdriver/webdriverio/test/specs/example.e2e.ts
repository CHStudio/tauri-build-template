describe("Hello Tauri", () => {
  it("should be cordial", async () => {
    const header = await $("body h2");
    const text = await header.getText();
    expect(text).toMatch(/^[hH]ello/);
  });

  it("should be excited", async function () {
    const header = await $("body h2");
    const text = await header.getText();
    expect(text).toMatch(/!$/);
  });
});

