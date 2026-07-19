import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["counter", "orb", "panel", "scrollProgress", "tab"]

  connect() {
    this.controllerConnected = true
    this.prefersReducedMotion = window.matchMedia(
      "(prefers-reduced-motion: reduce)",
    ).matches
    this.updateScrollProgress = this.updateScrollProgress.bind(this)

    window.addEventListener("scroll", this.updateScrollProgress, {
      passive: true,
    })
    this.updateScrollProgress()
    this.observeCounters()
  }

  disconnect() {
    this.controllerConnected = false
    window.removeEventListener("scroll", this.updateScrollProgress)
    this.counterObserver?.disconnect()

    if (this.scrollFrame) cancelAnimationFrame(this.scrollFrame)
  }

  selectMilestone(event) {
    this.activateTab(event.currentTarget)
  }

  navigateTabs(event) {
    const keys = ["ArrowLeft", "ArrowRight", "Home", "End"]
    if (!keys.includes(event.key)) return

    event.preventDefault()
    const currentIndex = this.tabTargets.indexOf(event.currentTarget)
    let nextIndex = currentIndex

    if (event.key === "ArrowLeft") {
      nextIndex = (currentIndex - 1 + this.tabTargets.length) % this.tabTargets.length
    } else if (event.key === "ArrowRight") {
      nextIndex = (currentIndex + 1) % this.tabTargets.length
    } else if (event.key === "Home") {
      nextIndex = 0
    } else if (event.key === "End") {
      nextIndex = this.tabTargets.length - 1
    }

    this.activateTab(this.tabTargets[nextIndex])
    this.tabTargets[nextIndex].focus()
  }

  activateTab(selectedTab) {
    const selectedKey = selectedTab.dataset.milestoneKey

    this.tabTargets.forEach((tab) => {
      const selected = tab === selectedTab
      tab.setAttribute("aria-selected", selected.toString())
      tab.tabIndex = selected ? 0 : -1
    })

    this.panelTargets.forEach((panel) => {
      panel.hidden = panel.dataset.milestoneKey !== selectedKey
    })
  }

  tilt(event) {
    if (this.prefersReducedMotion || !this.hasOrbTarget) return

    const bounds = event.currentTarget.getBoundingClientRect()
    const horizontal = (event.clientX - bounds.left) / bounds.width - 0.5
    const vertical = (event.clientY - bounds.top) / bounds.height - 0.5

    this.orbTarget.style.setProperty("--orb-rotate-x", `${vertical * -5}deg`)
    this.orbTarget.style.setProperty("--orb-rotate-y", `${horizontal * 5}deg`)
  }

  resetTilt() {
    if (!this.hasOrbTarget) return

    this.orbTarget.style.setProperty("--orb-rotate-x", "0deg")
    this.orbTarget.style.setProperty("--orb-rotate-y", "0deg")
  }

  updateScrollProgress() {
    if (this.scrollFrame) return

    this.scrollFrame = requestAnimationFrame(() => {
      const scrollableHeight =
        document.documentElement.scrollHeight - window.innerHeight
      const progress =
        scrollableHeight > 0 ? window.scrollY / scrollableHeight : 0

      if (this.hasScrollProgressTarget) {
        this.scrollProgressTarget.style.transform = `scaleX(${Math.min(Math.max(progress, 0), 1)})`
      }

      this.scrollFrame = null
    })
  }

  observeCounters() {
    if (this.prefersReducedMotion || !("IntersectionObserver" in window)) return

    this.counterTargets.forEach((counter) => {
      counter.textContent = "0"
    })

    this.counterObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting || entry.target.dataset.counted === "true") return

          entry.target.dataset.counted = "true"
          this.animateCounter(entry.target)
          this.counterObserver.unobserve(entry.target)
        })
      },
      { threshold: 0.45 },
    )

    this.counterTargets.forEach((counter) => this.counterObserver.observe(counter))
  }

  animateCounter(element) {
    const targetValue = Number(element.dataset.counterValue) || 0
    const formatter = new Intl.NumberFormat(
      document.documentElement.lang || undefined,
    )
    const duration = 900
    const startedAt = window.performance.now()

    const step = (now) => {
      if (!this.controllerConnected) return

      const elapsed = Math.min((now - startedAt) / duration, 1)
      const eased = 1 - (1 - elapsed) ** 3

      element.textContent = formatter.format(Math.round(targetValue * eased))

      if (elapsed < 1) requestAnimationFrame(step)
    }

    requestAnimationFrame(step)
  }
}
