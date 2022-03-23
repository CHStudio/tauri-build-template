import { shallowMount } from '@vue/test-utils';
import HelloWorld from '@/components/HelloWorld';

describe('HelloWorld component should', () => {
    it('display its text', () => {
        const wrapper = shallowMount(HelloWorld);

        const wizardHeader = wrapper.find('h2');

        expect(wizardHeader.exists()).toBe(true);
        expect(wizardHeader.text()).toBe('Hello world!');
    });
});
